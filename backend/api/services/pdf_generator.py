from reportlab.lib import colors
from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, Image as ReportLabImage
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch
from datetime import datetime
import os
from pathlib import Path
import json

class PDFGenerator:
    def __init__(self, output_dir: str = "backend/uploads/documents"):
        self.output_dir = output_dir
        self.styles = getSampleStyleSheet()
        self._create_custom_styles()
        
        # Ensure output directory exists
        Path(self.output_dir).mkdir(parents=True, exist_ok=True)

    def _create_custom_styles(self):
        self.styles.add(ParagraphStyle(
            name='Header',
            parent=self.styles['Heading1'],
            fontSize=16,
            spaceAfter=30,
            alignment=1  # Center
        ))
        self.styles.add(ParagraphStyle(
            name='SubHeader',
            parent=self.styles['Heading2'],
            fontSize=12,
            spaceAfter=12,
            textColor=colors.HexColor('#2c3e50')
        ))
        self.styles.add(ParagraphStyle(
            name='Label',
            parent=self.styles['Normal'],
            fontSize=10,
            textColor=colors.gray
        ))
        self.styles.add(ParagraphStyle(
            name='Value',
            parent=self.styles['Normal'],
            fontSize=10,
            spaceAfter=8
        ))

    def generate_inspection_report(self, form_data: dict, schema_title: str, user_name: str, filename: str = None) -> str:
        """
        Generates a PDF report for a generic inspection form.
        Returns the absolute path of the generated file.
        """
        if not filename:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            clean_title = schema_title.replace(" ", "_").lower()
            filename = f"acta_{clean_title}_{timestamp}.pdf"

        filepath = os.path.join(self.output_dir, filename)
        doc = SimpleDocTemplate(filepath, pagesize=letter)
        elements = []

        # 1. Header
        elements.append(Paragraph(f"ACTA DE INSPECCIÓN: {schema_title.upper()}", self.styles['Header']))
        elements.append(Spacer(1, 0.2 * inch))

        # 2. General Information Table
        data = [
            ["Fecha de Generación:", datetime.now().strftime("%Y-%m-%d %H:%M:%S")],
            ["Inspector / Responsable:", user_name],
            ["ID del Formulario:", form_data.get('id', 'N/A')],
            ["Ubicación:", form_data.get('ubicacion', 'No especificada')]
        ]
        
        t = Table(data, colWidths=[2.5*inch, 4*inch])
        t.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (0, -1), colors.HexColor('#f8f9fa')),
            ('TEXTCOLOR', (0, 0), (0, -1), colors.HexColor('#2d3748')),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (0, -1), 'Helvetica-Bold'),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 12),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.HexColor('#e2e8f0'))
        ]))
        elements.append(t)
        elements.append(Spacer(1, 0.4 * inch))

        # 3. Dynamic Content Form Data
        elements.append(Paragraph("Detalles de la Inspección", self.styles['SubHeader']))
        
        # Filter out metadata and focus on business fields
        exclude_keys = ['context', 'id', 'ubicacion']
        
        table_data = [['Item', 'Resultado']]
        
        for key, value in form_data.items():
            if key not in exclude_keys:
                # Format key
                clean_key = key.replace('_', ' ').capitalize()
                
                # Format value
                clean_value = str(value)
                if isinstance(value, bool):
                     clean_value = "CUMPLE" if value else "NO CUMPLE"
                elif clean_value.lower() == 'si':
                     clean_value = "CUMPLE"
                elif clean_value.lower() == 'no':
                     clean_value = "NO CUMPLE"
                
                table_data.append([clean_key, clean_value])

        t2 = Table(table_data, colWidths=[4*inch, 2.5*inch])
        t2.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#4a5568')),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, 0), 10),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
            ('BACKGROUND', (0, 1), (-1, -1), colors.HexColor('#ffffff')),
            ('GRID', (0, 0), (-1, -1), 1, colors.HexColor('#e2e8f0')),
            ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.HexColor('#ffffff'), colors.HexColor('#f7fafc')])
        ]))
        elements.append(t2)
        elements.append(Spacer(1, 0.5 * inch))

        # 4. Footer / Signatures
        elements.append(Spacer(1, 0.5 * inch))
        elements.append(Paragraph("_" * 40, self.styles['Normal']))
        elements.append(Paragraph("Firma del Inspector", self.styles['Value']))
        elements.append(Paragraph(user_name, self.styles['Value']))

        # Build PDF
        doc.build(elements)
        
        return filepath, filename, len(os.path.abspath(filepath))
