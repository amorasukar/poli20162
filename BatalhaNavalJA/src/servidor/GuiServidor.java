package servidor;

import javax.swing.JTextArea;

/**
 *
 * @author Amora
 */
public class GuiServidor extends javax.swing.JFrame {

    Servidor servidor;
    ThreadServidor threadServidor;

    public GuiServidor() {
        initComponents();
        jButton1.setEnabled(false);
    }


    @SuppressWarnings("unchecked")
    private void initComponents() {

        btConectar = new javax.swing.JButton();
        jLabel1 = new javax.swing.JLabel();
        jScrollPane1 = new javax.swing.JScrollPane();
        taStatus = new javax.swing.JTextArea();
        jButton1 = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        btConectar.setText("Conectar");
        btConectar.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                btConectarMouseClicked(evt);
            }
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                btConectarMouseReleased(evt);
            }
        });
        btConectar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btConectarActionPerformed(evt);
            }
        });

        jLabel1.setText("Status:");

        taStatus.setColumns(20);
        taStatus.setRows(5);
        jScrollPane1.setViewportView(taStatus);

        jButton1.setText("Desligar");
        jButton1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                jButton1MouseReleased(evt);
            }
        });
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 380, Short.MAX_VALUE)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(btConectar)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 232, Short.MAX_VALUE)
                        .addComponent(jButton1))
                    .addComponent(jLabel1))
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(btConectar)
                    .addComponent(jButton1))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jLabel1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 224, Short.MAX_VALUE)
                .addContainerGap())
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void btConectarMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_btConectarMouseClicked
            // TODO add your handling code here:
       
       // this.taStatus.append("testando o campo de texto");
    }//GEN-LAST:event_btConectarMouseClicked

    private void btConectarMouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_btConectarMouseReleased
        // TODO add your handling code here:
       // this.servidor = new Servidor(8090);
       
    }//GEN-LAST:event_btConectarMouseReleased

    private void jButton1MouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton1MouseReleased
        // TODO add your handling code here:
    }//GEN-LAST:event_jButton1MouseReleased

private void btConectarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btConectarActionPerformed
// TODO add your handling code here:
    //this.taStatus.append("Abrindo conexão...\n");
    threadServidor = new ThreadServidor(8090,this);
    threadServidor.start();
    //this.taStatus.append("Conectado.\n");
    btConectar.setEnabled(false);
    jButton1.setEnabled(true);
}//GEN-LAST:event_btConectarActionPerformed

private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
// TODO add your handling code here:
    //this.taStatus.append("Fechando conexão...\n");
    threadServidor.stopConexao();
    //sthis.taStatus.append("Fim da conexão.\n");
    btConectar.setEnabled(true);
    jButton1.setEnabled(false);
}//GEN-LAST:event_jButton1ActionPerformed

    /**
    * @param args the command line arguments
    */
    public static void main(String args[]) {
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new GuiServidor().setVisible(true);
            }
           
        });
    }

    public void mostrarMensagem(String msg){
        this.taStatus.append(msg);
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton btConectar;
    private javax.swing.JButton jButton1;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JScrollPane jScrollPane1;
    public javax.swing.JTextArea taStatus;
    // End of variables declaration//GEN-END:variables

    public JTextArea getTaStatus() {
        return taStatus;
    }

    public void setTaStatus(JTextArea taStatus) {
        this.taStatus = taStatus;
    }

}
